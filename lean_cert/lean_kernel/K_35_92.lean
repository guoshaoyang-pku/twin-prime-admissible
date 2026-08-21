import Sound
import lean_certs.cert_35_92

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H35_gt_92_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 35) (d := 92) (c := cert_35_92) (by decide)
