import Sound
import lean_certs.cert_34_76

open CertVerify

theorem H34_gt_76 : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 76 := by
  exact certValidRoot_sound (k := 34) (d := 76) (c := cert_34_76) (by native_decide)
