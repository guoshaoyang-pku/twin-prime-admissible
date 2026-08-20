import Sound
import lean_certs.cert_36_76

open CertVerify

theorem H36_gt_76 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 76 := by
  exact certValidRoot_sound (k := 36) (d := 76) (c := cert_36_76) (by native_decide)
