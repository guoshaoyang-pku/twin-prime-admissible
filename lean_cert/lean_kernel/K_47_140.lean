import Sound
import lean_certs.cert_47_140

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_140_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 140 := by
  exact certValidRoot_sound (k := 47) (d := 140) (c := cert_47_140) (by decide)
