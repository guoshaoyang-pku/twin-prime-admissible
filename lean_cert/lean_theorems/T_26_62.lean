import Sound
import lean_certs.cert_26_62

open CertVerify

theorem H26_gt_62 : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 62 := by
  exact certValidRoot_sound (k := 26) (d := 62) (c := cert_26_62) (by native_decide)
