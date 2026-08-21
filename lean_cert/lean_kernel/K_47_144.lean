import Sound
import lean_certs.cert_47_144

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_144_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 144 := by
  exact certValidRoot_sound (k := 47) (d := 144) (c := cert_47_144) (by decide)
