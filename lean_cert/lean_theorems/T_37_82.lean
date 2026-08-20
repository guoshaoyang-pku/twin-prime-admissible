import Sound
import lean_certs.cert_37_82

open CertVerify

theorem H37_gt_82 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 37) (d := 82) (c := cert_37_82) (by native_decide)
