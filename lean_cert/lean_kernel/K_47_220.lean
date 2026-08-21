import Sound
import lean_certs.cert_47_220

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H47_gt_220_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 220 := by
  exact certValidRoot_sound (k := 47) (d := 220) (c := cert_47_220) (by decide)
