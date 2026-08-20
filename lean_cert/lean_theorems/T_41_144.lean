import Sound
import lean_certs.cert_41_144

open CertVerify

theorem H41_gt_144 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 144 := by
  exact certValidRoot_sound (k := 41) (d := 144) (c := cert_41_144) (by native_decide)
