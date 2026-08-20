import Sound
import lean_certs.cert_24_82

open CertVerify

theorem H24_gt_82 : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 24) (d := 82) (c := cert_24_82) (by native_decide)
