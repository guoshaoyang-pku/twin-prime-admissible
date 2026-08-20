import Sound
import lean_certs.cert_30_82

open CertVerify

theorem H30_gt_82 : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 30) (d := 82) (c := cert_30_82) (by native_decide)
