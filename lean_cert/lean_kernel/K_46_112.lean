import Sound
import lean_certs.cert_46_112

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_112_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 46) (d := 112) (c := cert_46_112) (by decide)
