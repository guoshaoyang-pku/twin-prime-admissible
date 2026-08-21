import Sound
import lean_certs.cert_47_164

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_164_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 164 := by
  exact certValidRoot_sound (k := 47) (d := 164) (c := cert_47_164) (by decide)
