import Sound
import lean_certs.cert_48_144

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_144_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 144 := by
  exact certValidRoot_sound (k := 48) (d := 144) (c := cert_48_144) (by decide)
