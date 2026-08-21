import Sound
import lean_certs.cert_39_144

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_144_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 144 := by
  exact certValidRoot_sound (k := 39) (d := 144) (c := cert_39_144) (by decide)
