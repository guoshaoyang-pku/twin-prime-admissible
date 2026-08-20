import Sound
import lean_certs.cert_47_118

open CertVerify

theorem H47_gt_118 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 118 := by
  exact certValidRoot_sound (k := 47) (d := 118) (c := cert_47_118) (by native_decide)
