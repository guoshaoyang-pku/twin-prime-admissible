import Sound
import lean_certs.cert_33_144

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H33_gt_144_kernel : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 144 := by
  exact certValidRoot_sound (k := 33) (d := 144) (c := cert_33_144) (by decide)
