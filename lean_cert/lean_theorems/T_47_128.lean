import Sound
import lean_certs.cert_47_128

open CertVerify

theorem H47_gt_128 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 128 := by
  exact certValidRoot_sound (k := 47) (d := 128) (c := cert_47_128) (by native_decide)
