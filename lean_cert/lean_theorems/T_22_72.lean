import Sound
import lean_certs.cert_22_72

open CertVerify

theorem H22_gt_72 : ¬ ∃ t : List Nat, admissible 22 t = true ∧ diameter t ≤ 72 := by
  exact certValidRoot_sound (k := 22) (d := 72) (c := cert_22_72) (by native_decide)
