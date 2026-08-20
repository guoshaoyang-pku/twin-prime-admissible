import Sound
import lean_certs.cert_32_144

open CertVerify

theorem H32_gt_144 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 144 := by
  exact certValidRoot_sound (k := 32) (d := 144) (c := cert_32_144) (by native_decide)
