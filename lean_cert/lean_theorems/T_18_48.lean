import Sound
import lean_certs.cert_18_48

open CertVerify

theorem H18_gt_48 : ¬ ∃ t : List Nat, admissible 18 t = true ∧ diameter t ≤ 48 := by
  exact certValidRoot_sound (k := 18) (d := 48) (c := cert_18_48) (by native_decide)
