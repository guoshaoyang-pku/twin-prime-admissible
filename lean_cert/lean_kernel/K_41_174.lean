import Sound
import lean_certs.cert_41_174

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H41_gt_174_kernel : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 174 := by
  exact certValidRoot_sound (k := 41) (d := 174) (c := cert_41_174) (by decide)
