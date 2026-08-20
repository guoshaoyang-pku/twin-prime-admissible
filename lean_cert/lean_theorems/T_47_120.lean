import Sound
import lean_certs.cert_47_120

open CertVerify

theorem H47_gt_120 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 120 := by
  exact certValidRoot_sound (k := 47) (d := 120) (c := cert_47_120) (by native_decide)
