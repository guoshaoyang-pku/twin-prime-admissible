import Sound
import lean_certs.cert_47_164

open CertVerify

theorem H47_gt_164 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 164 := by
  exact certValidRoot_sound (k := 47) (d := 164) (c := cert_47_164) (by native_decide)
