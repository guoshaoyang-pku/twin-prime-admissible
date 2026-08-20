import Sound
import lean_certs.cert_30_76

open CertVerify

theorem H30_gt_76 : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 76 := by
  exact certValidRoot_sound (k := 30) (d := 76) (c := cert_30_76) (by native_decide)
