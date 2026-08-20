import Sound
import lean_certs.cert_23_76

open CertVerify

theorem H23_gt_76 : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 76 := by
  exact certValidRoot_sound (k := 23) (d := 76) (c := cert_23_76) (by native_decide)
