import Sound
import lean_certs.cert_31_82

open CertVerify

theorem H31_gt_82 : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 31) (d := 82) (c := cert_31_82) (by native_decide)
