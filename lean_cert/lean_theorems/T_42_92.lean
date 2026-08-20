import Sound
import lean_certs.cert_42_92

open CertVerify

theorem H42_gt_92 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 42) (d := 92) (c := cert_42_92) (by native_decide)
