import Sound
import lean_certs.cert_47_180

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_180_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 180 := by
  exact certValidRoot_sound (k := 47) (d := 180) (c := cert_47_180) (by decide)
