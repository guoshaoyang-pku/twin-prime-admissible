import Sound
import lean_certs.cert_42_86

open CertVerify

theorem H42_gt_86 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 86 := by
  exact certValidRoot_sound (k := 42) (d := 86) (c := cert_42_86) (by native_decide)
