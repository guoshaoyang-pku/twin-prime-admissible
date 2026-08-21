import Sound
import lean_certs.cert_47_96

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_96_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 47) (d := 96) (c := cert_47_96) (by decide)
