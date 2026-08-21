import Sound
import lean_certs.cert_41_104

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H41_gt_104_kernel : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 41) (d := 104) (c := cert_41_104) (by decide)
