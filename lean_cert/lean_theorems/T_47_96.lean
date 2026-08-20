import Sound
import lean_certs.cert_47_96

open CertVerify

theorem H47_gt_96 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 47) (d := 96) (c := cert_47_96) (by native_decide)
