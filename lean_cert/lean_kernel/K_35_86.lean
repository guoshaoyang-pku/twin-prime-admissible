import Sound
import lean_certs.cert_35_86

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H35_gt_86_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 86 := by
  exact certValidRoot_sound (k := 35) (d := 86) (c := cert_35_86) (by decide)
