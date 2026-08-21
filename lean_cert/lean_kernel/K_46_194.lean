import Sound
import lean_certs.cert_46_194

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_194_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 194 := by
  exact certValidRoot_sound (k := 46) (d := 194) (c := cert_46_194) (by decide)
