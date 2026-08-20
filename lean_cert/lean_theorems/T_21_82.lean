import Sound
import lean_certs.cert_21_82

open CertVerify

theorem H21_gt_82 : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 21) (d := 82) (c := cert_21_82) (by native_decide)
