import Sound
import lean_certs.cert_48_144

open CertVerify

theorem H48_gt_144 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 144 := by
  exact certValidRoot_sound (k := 48) (d := 144) (c := cert_48_144) (by native_decide)
