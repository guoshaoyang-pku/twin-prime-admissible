import Sound
import lean_certs.cert_46_144

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_144_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 144 := by
  exact certValidRoot_sound (k := 46) (d := 144) (c := cert_46_144) (by decide)
