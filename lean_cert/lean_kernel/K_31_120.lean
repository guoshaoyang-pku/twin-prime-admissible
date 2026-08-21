import Sound
import lean_certs.cert_31_120

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H31_gt_120_kernel : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 120 := by
  exact certValidRoot_sound (k := 31) (d := 120) (c := cert_31_120) (by decide)
