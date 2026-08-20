import Sound
import lean_certs.cert_47_202

open CertVerify

theorem H47_gt_202 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 202 := by
  exact certValidRoot_sound (k := 47) (d := 202) (c := cert_47_202) (by native_decide)
