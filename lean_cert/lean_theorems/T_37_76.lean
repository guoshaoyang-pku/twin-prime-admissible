import Sound
import lean_certs.cert_37_76

open CertVerify

theorem H37_gt_76 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 76 := by
  exact certValidRoot_sound (k := 37) (d := 76) (c := cert_37_76) (by native_decide)
