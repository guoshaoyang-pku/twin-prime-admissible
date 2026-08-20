import Sound
import lean_certs.cert_49_144

open CertVerify

theorem H49_gt_144 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 144 := by
  exact certValidRoot_sound (k := 49) (d := 144) (c := cert_49_144) (by native_decide)
