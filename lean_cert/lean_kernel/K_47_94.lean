import Sound
import lean_certs.cert_47_94

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_94_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 94 := by
  exact certValidRoot_sound (k := 47) (d := 94) (c := cert_47_94) (by decide)
