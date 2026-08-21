import Sound
import lean_certs.cert_47_184

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_184_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 184 := by
  exact certValidRoot_sound (k := 47) (d := 184) (c := cert_47_184) (by decide)
