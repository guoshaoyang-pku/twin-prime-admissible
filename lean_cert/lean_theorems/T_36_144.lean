import Sound
import lean_certs.cert_36_144

open CertVerify

theorem H36_gt_144 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 144 := by
  exact certValidRoot_sound (k := 36) (d := 144) (c := cert_36_144) (by native_decide)
