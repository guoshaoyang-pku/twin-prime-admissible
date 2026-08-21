import Sound
import lean_certs.cert_45_144

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_144_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 144 := by
  exact certValidRoot_sound (k := 45) (d := 144) (c := cert_45_144) (by decide)
