import Sound
import lean_certs.cert_26_76

open CertVerify

theorem H26_gt_76 : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 76 := by
  exact certValidRoot_sound (k := 26) (d := 76) (c := cert_26_76) (by native_decide)
