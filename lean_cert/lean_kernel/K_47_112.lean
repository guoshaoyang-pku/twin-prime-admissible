import Sound
import lean_certs.cert_47_112

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_112_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 47) (d := 112) (c := cert_47_112) (by decide)
