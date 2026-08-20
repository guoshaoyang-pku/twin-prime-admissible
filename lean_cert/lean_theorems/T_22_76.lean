import Sound
import lean_certs.cert_22_76

open CertVerify

theorem H22_gt_76 : ¬ ∃ t : List Nat, admissible 22 t = true ∧ diameter t ≤ 76 := by
  exact certValidRoot_sound (k := 22) (d := 76) (c := cert_22_76) (by native_decide)
