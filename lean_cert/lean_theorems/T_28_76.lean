import Sound
import lean_certs.cert_28_76

open CertVerify

theorem H28_gt_76 : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 76 := by
  exact certValidRoot_sound (k := 28) (d := 76) (c := cert_28_76) (by native_decide)
