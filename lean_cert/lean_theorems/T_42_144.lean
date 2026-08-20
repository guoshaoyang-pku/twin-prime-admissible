import Sound
import lean_certs.cert_42_144

open CertVerify

theorem H42_gt_144 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 144 := by
  exact certValidRoot_sound (k := 42) (d := 144) (c := cert_42_144) (by native_decide)
