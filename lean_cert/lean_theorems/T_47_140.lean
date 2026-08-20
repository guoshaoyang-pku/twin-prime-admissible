import Sound
import lean_certs.cert_47_140

open CertVerify

theorem H47_gt_140 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 140 := by
  exact certValidRoot_sound (k := 47) (d := 140) (c := cert_47_140) (by native_decide)
