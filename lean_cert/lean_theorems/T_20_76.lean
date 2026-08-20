import Sound
import lean_certs.cert_20_76

open CertVerify

theorem H20_gt_76 : ¬ ∃ t : List Nat, admissible 20 t = true ∧ diameter t ≤ 76 := by
  exact certValidRoot_sound (k := 20) (d := 76) (c := cert_20_76) (by native_decide)
