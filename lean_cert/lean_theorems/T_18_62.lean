import Sound
import lean_certs.cert_18_62

open CertVerify

theorem H18_gt_62 : ¬ ∃ t : List Nat, admissible 18 t = true ∧ diameter t ≤ 62 := by
  exact certValidRoot_sound (k := 18) (d := 62) (c := cert_18_62) (by native_decide)
