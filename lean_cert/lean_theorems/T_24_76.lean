import Sound
import lean_certs.cert_24_76

open CertVerify

theorem H24_gt_76 : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 76 := by
  exact certValidRoot_sound (k := 24) (d := 76) (c := cert_24_76) (by native_decide)
