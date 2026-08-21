import Sound
import lean_certs.cert_47_160

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_160_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 160 := by
  exact certValidRoot_sound (k := 47) (d := 160) (c := cert_47_160) (by decide)
